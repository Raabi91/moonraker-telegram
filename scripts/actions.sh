#!/bin/bash

light_on()
{
    if [ -n "${led_on}" ]; then
        echo "Led on" >> "$log/$multi_instanz.log"
        curl --connect-timeout 2  -H "Content-Type: application/json" -X POST "$led_on"
        sleep "$led_on_delay"
    fi
}

light_off()
{
    if [ "$gif_enable" = "0" ]; then
        if [ -n "${led_off}" ]; then
            sleep "$led_off_delay"
            curl --connect-timeout 2  -H "Content-Type: application/json" -X POST "$led_off"
            echo "LED off" >> "$log/$multi_instanz.log"
        fi
    fi
}

take_picture()
{
    if curl --output /dev/null --silent --fail -r 0-0  "$item"; then
        echo "Webcam$array link is working" >> "$log/$multi_instanz.log"

        rm "$DIR_TEL/picture/cam_new$array.jpg"
        curl -m 20 -o "$DIR_TEL/picture/cam_new$array.jpg" "$item"

        if identify -format '%f' "$DIR_TEL/picture/cam_new$array.jpg"; then
            echo "Jpeg$array file is okay" >> "$log/$multi_instanz.log"
            if [ ! -z "${rotate[$array]}" ]; then
                convert -quiet -rotate "${rotate[$array]}" "$DIR_TEL/picture/cam_new$array.jpg" "$DIR_TEL/picture/cam_new$array.jpg"
            fi
            if [ ! -z "${horizontally[$array]}" ]; then
                if [ "${horizontally[$array]}" = "1" ]; then
                    convert -quiet -flop "$DIR_TEL/picture/cam_new$array.jpg" "$DIR_TEL/picture/cam_new$array.jpg"
                fi
            fi
            if [ ! -z "${vertically[$array]}"  ]; then
                if [ "${vertically[$array]}" = "1" ]; then
                    convert -quiet -flip "$DIR_TEL/picture/cam_new$array.jpg" "$DIR_TEL/picture/cam_new$array.jpg"
                fi
            fi
        else
            echo "JPEG$array picture has an error" >> "$log/$multi_instanz.log"
            rm "$DIR_TEL/picture/cam_new$array.jpg"
            cp "$DIR_TEL/picture/cam_error.jpg" "$DIR_TEL/picture/cam_new$array.jpg"
        fi
    else
        echo "Webcam$array link has an error" >> "$log/$multi_instanz.log"
        cp "$DIR_TEL/picture/no_cam.jpg" "$DIR_TEL/picture/cam_new$array.jpg"
    fi
}

create_variables()
{
    print=$(curl -H "X-Api-Key: $api_key" -s "http://127.0.0.1:$port/printer/objects/query?print_stats&virtual_sdcard&display_status&gcode_move&extruder=target,temperature&heater_bed=target,temperature")
    #### Filename ####
    print_filename=$(echo "$print" | grep -oP '(?<="filename": ")[^"]*')
    filename=$(echo $print_filename | sed -f $DIR_TEL/scripts/url_escape.sed)

    if [ -z "$filename" ]; then
        file=""
    else
        file=$(curl -H "X-Api-Key: $api_key" -s "http://127.0.0.1:$port/server/files/metadata?filename=$filename")
    fi
    #### Duration ####
    print_duration=$(echo "$print" | grep -oP '(?<="print_duration": )[^,]*')
    total_duration=$(echo "$print" | grep -oP '(?<="total_duration": )[^,]*')
    #### Progress ###
    gcode_start_byte=$(echo "$file" | grep -oP '(?<="gcode_start_byte": )[^,]*')
    gcode_end_byte=$(echo "$file" | grep -oP '(?<="gcode_end_byte": )[^,]*')
    file_position=$(echo "$print" | grep -oP '(?<="file_position": )[^,]*')
    if [ "$file_position" -gt "$gcode_end_byte" ]; then
        progress="1"
    else
        positon_gcode=$(echo "$file_position-$gcode_start_byte" | bc -l)
        gcode_length=$(echo "$gcode_end_byte-$gcode_start_byte" | bc -l)
        progress=$(echo "$positon_gcode/$gcode_length" | bc -l)
    fi
    #### Print_state ####
    print_state_read1=$(echo "$print" | grep -oP '(?<="state": ")[^"]*')
    #### Extruder Temps ####
    extruder=$(echo "$print" | grep -oP '(?<="extruder": {)[^}]*')
    extruder_target=$(echo "$extruder" | grep -oP '(?<="target": )[^,]*')
    extruder_temp1=$(echo "$extruder" | grep -oP '(?<="temperature": )[^,]*')
    extruder_temp=$(printf %.2f $extruder_temp1)
    #### Heater_Bed Temps ####
    heater_bed=$(echo "$print" | grep -oP '(?<="heater_bed": {)[^}]*')
    bed_target=$(echo "$heater_bed" | grep -oP '(?<="target": )[^,]*')
    bed_temp1=$(echo "$heater_bed" | grep -oP '(?<="temperature": )[^,]*')
    if [ "$bed_temp1" != "null" ]; then
        bed_temp=$(printf %.2f $bed_temp1)
    fi

    if [ -z "$file" ]; then
        echo "file is empty"
    else
        layer_height=$(echo "$file" | grep -oP '(?<="layer_height": )[^,]*')
        first_layer_height=$(echo "$file" | grep -oP '(?<="first_layer_height": )[^,]*')
        object_height=$(echo "$file" | grep -oP '(?<="object_height": )[^,]*')
        gcode_position=$(echo "$print" | grep -oP '(?<="gcode_position": )[^"]*')
        gcode_position="${gcode_position// /}"
        IFS=',' read -r -a array <<< "$gcode_position"
        z_current=$(echo "${array[2]}")

        echo "$z_current"
        echo "$first_layer_height"

        if (( $(echo "$z_current > $first_layer_height" | bc -l) )); then
            layer1=$(echo "scale=0; $z_current-$first_layer_height" | bc -l)
            layer2=$(echo "scale=0; $layer1/$layer_height" | bc -l)
            current_layer=$(echo "scale=0; $layer2+1" | bc -l)
        else
            current_layer=1
        fi


        layer1=$(echo "scale=0; $object_height-$first_layer_height" | bc -l)
        layer2=$(echo "scale=0; $layer1/$layer_height" | bc -l)
        layers=$(echo "scale=0; $layer2+1" | bc -l)
    fi

    #### Remaining to H M S ####
    if [ "$print_duration" = "0.0" ]; then
        math2="0"
    else
        if [ "$progress" <= "0.0" ]; then
            math2="0"
            math4="0"
            math8="0"
        else
            math1=$(echo "scale=0; $print_duration/$progress" | bc -l)
            math2=$(echo "scale=0; $math1-$print_duration" | bc -l)

            math3=$(echo "scale=0; $total_duration/$progress" | bc -l)
            math4=$(echo "scale=0; $math3-$print_duration" | bc -l)

            math5=$(echo "scale=0; $total_duration+$print_duration" | bc -l)
            math6=$(echo "scale=0; $math5/2" | bc -l)
            math7=$(echo "scale=0; $math6/$progress" | bc -l)
            math8=$(echo "scale=0; $math7-$math6" | bc -l)
        fi
    fi

    remaining=$(printf "%.0f" $math2)
    print_remaining=$(printf '%02d:%02d:%02d\n' $(($remaining/3600)) $(($remaining%3600/60)) $(($remaining%60)))

    remaining1=$(printf "%.0f" $math4)
    total_remaining=$(printf '%02d:%02d:%02d\n' $(($remaining1/3600)) $(($remaining1%3600/60)) $(($remaining1%60)))
    
    remaining2=$(printf "%.0f" $math8)
    calculate_remaining=$(printf '%02d:%02d:%02d\n' $(($remaining2/3600)) $(($remaining2%3600/60)) $(($remaining2%60)))

    #### Current to H M S ####
    current=$(printf "%.0f" $print_duration)
    print_current=$(printf '%02d:%02d:%02d\n' $(($current/3600)) $(($current%3600/60)) $(($current%60)))

    current1=$(printf "%.0f" $total_duration)
    total_current=$(printf '%02d:%02d:%02d\n' $(($current1/3600)) $(($current1%3600/60)) $(($current1%60)))

    #### Progress to % ####
    print_progress1=$(echo "scale=1; $progress*100" | bc )
    print_progress=$(printf "%.1f" $print_progress1)%
}