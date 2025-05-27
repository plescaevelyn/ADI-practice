#! /bin/bash

# Ask user for script name
read -p "heyyy brush would rlly appreciate u giving me a name for my script thx :3 :* " script_name

# Create script using given name
touch ${script_name}.exe

# Add test echo command to the script
echo -e '#!/bin/bash\necho "ur glowing queen"' > "${script_name}.exe"

# Make the script executable
chmod +x ${script_name}.exe

# Run the new executable file
./${script_name}.exe
