import xml.etree.ElementTree as ET

def update_revisions(source_file, target_file, output_file):

    source_tree = ET.parse(source_file)
    source_root = source_tree.getroot()

    target_tree = ET.parse(target_file)
    target_root = target_tree.getroot()

    target_revisions = {
        project.attrib["path"]: project.attrib.get("revision", "")
        for project in target_root.findall("project")
    }

    for project in source_root.findall("project"):
        path = project.attrib.get("path")
        if path in target_revisions:
            old_revision = project.attrib.get("revision", "")
            new_revision = target_revisions[path]
            if old_revision != new_revision:
                print(f"Update for {path}: {old_revision} -> {new_revision}")
                project.attrib["revision"] = new_revision

    source_tree.write(output_file, encoding="utf-8", xml_declaration=True)
    print(f"Updated file: {output_file}")


source_file = "system_1.xml"
target_file = "system_2.xml"
output_file = "system_updated.xml"

update_revisions(source_file, target_file, output_file)
