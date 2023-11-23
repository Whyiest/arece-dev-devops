import sys

template_path = sys.argv[1]
output_path = sys.argv[2]
username = sys.argv[3]
volume_instruction = sys.argv[4]
gpu_instruction = sys.argv[5]


# Lire le contenu du fichier template
with open(template_path, 'r') as file:
    content = file.read()

# Remplacer les placeholders
content = content.replace('USERNAME_PLACEHOLDER', username)
content = content.replace('VOLUME_PLACEHOLDER', volume_instruction)
if gpu_instruction and gpu_instruction != 'null' and gpu_instruction != 'UNKNOWN':
    content = content.replace('DEVICE_PLACEHOLDER', gpu_instruction)
else:
    content = content.replace('    DEVICE_PLACEHOLDER\n', '')  # Supprimer la ligne si DEVICE_PLACEHOLDER est vide

# Écrire le contenu modifié dans le fichier de sortie
with open(output_path, 'w') as file:
    file.write(content)
