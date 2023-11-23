import sys

template_path = sys.argv[1]
output_path = sys.argv[2]
username = sys.argv[3]
volume_instruction = sys.argv[4]
device_instruction = sys.argv[5]
environment_instruction = sys.argv[6]

# Lire le contenu du fichier template
with open(template_path, 'r') as file:
    content = file.read()

# Remplacer les placeholders
content = content.replace('USERNAME_PLACEHOLDER', username)
content = content.replace('VOLUME_PLACEHOLDER', volume_instruction)

if device_instruction and device_instruction != 'null' and device_instruction != 'UNKNOWN':
    content = content.replace('DEVICE_PLACEHOLDER', device_instruction.replace('\\n', '\n'))
else:
    content = content.replace('    DEVICE_PLACEHOLDER\n', '')  # Supprimer la ligne si DEVICE_PLACEHOLDER est vide

if environment_instruction and environment_instruction != 'null' and environment_instruction != 'UNKNOWN':
    content = content.replace('ENVIRONMENT_PLACEHOLDER', environment_instruction.replace('\\n', '\n'))
else:
    content = content.replace('    ENVIRONMENT_PLACEHOLDER\n', '')  # Supprimer la ligne si ENVIRONMENT_PLACEHOLDER est vide

# Écrire le contenu modifié dans le fichier de sortie
with open(output_path, 'w') as file:
    file.write(content)
