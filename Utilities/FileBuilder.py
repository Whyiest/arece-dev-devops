import sys

template_path = sys.argv[1]
output_path = sys.argv[2]
username = sys.argv[3]
GPU = sys.argv[4] 

# Lire le contenu du fichier template
with open(template_path, 'r') as file:
    content = file.read()

# Remplacer les placeholders
content = content.replace('USERNAME_PLACEHOLDER', username)
if (GPU != 'UNKNOWN') and (GPU != 'null'):
    content = content.replace('DEVICE_PLACEHOLDER', GPU)
else:
    content = content.replace('    DEVICE_PLACEHOLDER\n', '')  # Supprimer la ligne si DEVICE_CONFIG est vide

# Écrire le contenu modifié dans le fichier de sortie
with open(output_path, 'w') as file:
    file.write(content)
