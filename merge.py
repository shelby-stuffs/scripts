import xml.etree.ElementTree as ET

def update_revisions(source_file, target_file, output_file, log_file):
    source_tree = ET.parse(source_file)
    source_root = source_tree.getroot()

    target_tree = ET.parse(target_file)
    target_root = target_tree.getroot()

    target_revisions = {
        project.attrib["path"]: project.attrib.get("revision", "")
        for project in target_root.findall("project")
    }

    with open(log_file, "w", encoding="utf-8") as log:
        for project in source_root.findall("project"):
            path = project.attrib.get("path")
            if path in target_revisions:
                old_revision = project.attrib.get("revision", "")
                new_revision = target_revisions[path]
                if old_revision != new_revision:
                    log.write(f"{path}: {old_revision} -> {new_revision}\n")
                    project.attrib["revision"] = new_revision

        added_projects = []
        for project in target_root.findall("project"):
            path = project.attrib.get("path")
            if not any(proj.attrib.get("path") == path for proj in source_root.findall("project")):
                added_projects.append(project.attrib)

        if added_projects:
            log.write("\nAdded projects:\n")
            for project in added_projects:
                log.write(f"Project: {project['name']}, Path: {project['path']}, Revision: {project['revision']}\n")
        else:
            log.write("\nNone new projects.\n")

    source_tree.write(output_file, encoding="utf-8", xml_declaration=True)
    print(f"Updated manifest to: {output_file}")
    print(f"Log file: {log_file}")

source_file = "aospa.xml"
target_file = "qssi.xml"
output_file = "system.xml"
log_file = "result.txt"

update_revisions(source_file, target_file, output_file, log_file)
