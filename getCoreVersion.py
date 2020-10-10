import xml.etree.ElementTree as ET
with open("./ChartGenerator-Server/ChartGenerator-Server.csproj",encoding='UTF-8-sig') as config:
    tree = ET.parse(config)
    root = tree.getroot()
    for item in root.findall('./ItemGroup/PackageReference'): 
        if item.attrib['Include'] == "ChartGenerator-Chart.js":
            print(item.attrib['Version'])