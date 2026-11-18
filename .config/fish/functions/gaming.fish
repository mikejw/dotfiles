function gaming --description "Toggle macOS AWDL for gaming"
    switch $argv[1]
        case on
            sudo ifconfig awdl0 down
            echo "Gaming mode ON (AWDL disabled)"

        case off
            sudo ifconfig awdl0 up
            echo "Gaming mode OFF (AWDL enabled)"

        case status
            if ifconfig awdl0 | grep -q 'flags=.*<.*UP'
                echo "Gaming mode OFF (AWDL enabled)"
            else
                echo "Gaming mode ON (AWDL disabled)"
            end

        case '*'
            echo "Usage: gaming {on|off|status}"
            return 1
    end
end
