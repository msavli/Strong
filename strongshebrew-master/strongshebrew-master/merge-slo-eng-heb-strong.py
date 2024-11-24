from lxml import etree

def merge_tei_files(slo_file, eng_file, output_file):
    # Parse the XML files
    slo_tree = etree.parse(slo_file)
    eng_tree = etree.parse(eng_file)

    # Get the root elements
    slo_root = slo_tree.getroot()
    eng_root = eng_tree.getroot()

    # Preserve namespaces
    namespaces = slo_root.nsmap

    # Create a new root element for the merged document
    merged_root = etree.Element(slo_root.tag, nsmap=namespaces)

    # Copy the <teiHeader> section from the Slovenian file
    tei_header = slo_root.find("teiHeader", namespaces)
    if tei_header is not None:
        merged_root.append(tei_header)

    # Find the <text> section in both files
    slo_text = slo_root.find("text", namespaces)
    eng_text = eng_root.find("text", namespaces)

    if slo_text is None or eng_text is None:
        raise ValueError("Missing <text> section in one or both files.")

    # Create a new <text> element for the merged content
    merged_text = etree.SubElement(merged_root, "text")
    merged_body = etree.SubElement(merged_text, "body")

    # Build a dictionary for English entries based on their 'n' attribute
    eng_entries = {entry.get('n'): entry for entry in eng_text.findall(".//entryFree", namespaces)}

    # Iterate through Slovenian entries and merge with corresponding English entries
    for slo_entry in slo_text.findall(".//entryFree", namespaces):
        n_attr = slo_entry.get('n')
        merged_entry = etree.Element(slo_entry.tag, slo_entry.attrib)

        # Append a <title>SLO</title> tag
        slo_title = etree.Element("p")
        slo_title.text = "SLO"
        merged_entry.append(slo_title)

        # Append Slovenian content
        merged_entry.extend(slo_entry)

        # Append a <title>ENG</title> tag if English content exists
        if n_attr in eng_entries:
            eng_title = etree.Element("p")
            eng_title.text = "ENG"
            merged_entry.append(eng_title)

            # Append English content
            eng_entry = eng_entries[n_attr]
            merged_entry.extend(eng_entry)

        # Add merged entry to the body
        merged_body.append(merged_entry)

    # Write the merged content to the output file
    merged_tree = etree.ElementTree(merged_root)
    with open(output_file, 'wb') as f:
        merged_tree.write(f, encoding='UTF-8', pretty_print=True, xml_declaration=True)

# File paths
slo_file = 'slostrongshebrew.tei.xml'
eng_file = 'strongshebrew.tei.xml'
output_file = 'merged_strongshebrew.tei.xml'

# Merge the files
merge_tei_files(slo_file, eng_file, output_file)

print(f"Merged file saved as {output_file}")
