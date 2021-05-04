#!/usr/bin/python3
#
# CI-Script to update .github/workflows/build-docker-image.yml with the latest Versions for
# the Job "build-docker-image", subkey:
#   strategy:
#     matrix:
#       version:
#
###################################################################################################
import urllib.request
import urllib.parse
import json


###################################################################################################
# Variables
###################################################################################################
docker_api = "https://registry.hub.docker.com/api/content/v1/repositories/public/"
file = ".github/workflows/build-docker-image.yml"


###################################################################################################
# Functions
###################################################################################################

def get_schema_is_valid(tag_name, schema, release):
    if schema == "vNUMBER.NUMBER.NUMBER-stable-NUMBER.NUMBER-STRING-*":
        # String must start with a "v"
        if not tag_name.startswith("v"):
            return False

        # String needs to contain dashes
        try:
            dash_split = tag_name.split("-")
        except ValueError:
            return False

        # String needs exactly three dashes
        if len(dash_split) < 4:
            return False

        # Inspect first part: vNUMBER.NUMBER.NUMBER
        try:
            helper1 = dash_split[0][1:].split(".")
        except ValueError:
            return False

        if len(helper1) != 3:
            return False

        if not helper1[0].isdigit() or not helper1[1].isdigit() or not helper1[2].isdigit():
            return False

        # Inspect second part: stable
        if not dash_split[1] == "stable":
            return False

        # Inspect third part: NUMBER.NUMBER
        try:
            helper3 = dash_split[2].split(".")
        except ValueError:
            return False

        if len(helper3) != 2:
            return False

        if not helper3[0].isdigit() or not helper3[1].isdigit():
            return False

        # Inspect fourth part: STRING
        if not dash_split[3] == release:
            return False

        return True

    return False


def get_api_generic_latest_tag(api, owner, repo, key):
    with urllib.request.urlopen(api + owner + "/" + repo + "/" + key) as url:
        return json.loads(url.read().decode())


def get_api_docker_latest_tag(owner, repo, schema, release, page_number=1):
    query_extension="tags?page_size=100"
    query_extension=query_extension + "&page=" + str(page_number)
    result = get_api_generic_latest_tag(docker_api, owner, repo, query_extension)
    for entry in result['results']:
        if get_schema_is_valid(entry['name'], schema, release):
            return entry['name']

    # if none was found, recall yourself
    return get_api_docker_latest_tag(owner, repo, schema, release, page_number + 1)


###################################################################################################

def get_luminous_latest_tag():
    return_value = get_api_docker_latest_tag("ceph", "daemon-base", "vNUMBER.NUMBER.NUMBER-stable-NUMBER.NUMBER-STRING-*", "luminous")
    # Transform vNUMBER.NUMBER.NUMBER-stable-NUMBER.NUMBER-STRING-* into vNUMBER.NUMBER.NUMBER-stable-NUMBER.NUMBER-STRING
    return_value = return_value.split("-")
    return_value = return_value[0] + "-" + return_value[1] + "-" + return_value[2] + "-" + return_value[3]
    return return_value


def get_nautilus_latest_tag():
    return_value = get_api_docker_latest_tag("ceph", "daemon-base", "vNUMBER.NUMBER.NUMBER-stable-NUMBER.NUMBER-STRING-*", "nautilus")
    # Transform vNUMBER.NUMBER.NUMBER-stable-NUMBER.NUMBER-STRING-* into vNUMBER.NUMBER.NUMBER-stable-NUMBER.NUMBER-STRING
    return_value = return_value.split("-")
    return_value = return_value[0] + "-" + return_value[1] + "-" + return_value[2] + "-" + return_value[3]
    return return_value


def get_octopus_latest_tag():
    return_value = get_api_docker_latest_tag("ceph", "daemon-base", "vNUMBER.NUMBER.NUMBER-stable-NUMBER.NUMBER-STRING-*", "octopus")
    # Transform vNUMBER.NUMBER.NUMBER-stable-NUMBER.NUMBER-STRING-* into vNUMBER.NUMBER.NUMBER-stable-NUMBER.NUMBER-STRING
    return_value = return_value.split("-")
    return_value = return_value[0] + "-" + return_value[1] + "-" + return_value[2] + "-" + return_value[3]
    return return_value


def get_pacific_latest_tag():
    return_value = get_api_docker_latest_tag("ceph", "daemon-base", "vNUMBER.NUMBER.NUMBER-stable-NUMBER.NUMBER-STRING-*", "pacific")
    # Transform vNUMBER.NUMBER.NUMBER-stable-NUMBER.NUMBER-STRING-* into vNUMBER.NUMBER.NUMBER-stable-NUMBER.NUMBER-STRING
    return_value = return_value.split("-")
    return_value = return_value[0] + "-" + return_value[1] + "-" + return_value[2] + "-" + return_value[3]
    return return_value


def set_build_docker_image(
        latest_luminous_version,
        latest_nautilus_version,
        latest_octopus_verison,
        latest_pacific_version):
    print(locals().values())

    # insert blank lines for better readability
    with open(file, "r") as stream:
        buf = stream.readlines()
    with open(file, "w") as stream:
        for line in buf:
            latest_version = ""
            if ("-luminous" in line and not line.startswith("#")):
                latest_version = latest_luminous_version
            if ("-nautilus" in line and not line.startswith("#")):
                latest_version = latest_nautilus_version
            if ("-octopus" in line and not line.startswith("#")):
                latest_version = latest_octopus_verison
            if ("-pacific" in line and not line.startswith("#")):
                latest_version = latest_pacific_version

            if not latest_version == "":
                line = "          - " + latest_version + "\n"
            stream.write(line)


###################################################################################################
# Main
###################################################################################################
set_build_docker_image(get_luminous_latest_tag(),
                       get_nautilus_latest_tag(),
                       get_octopus_latest_tag(),
                       get_pacific_latest_tag())
