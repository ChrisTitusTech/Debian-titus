#!/usr/bin/python3

import apt_pkg
import re

# list of lists, in the form [ 'sourcefile.list.chroot', 'destinationfile.md' ]
package_lists = [
	[ 'config/package-lists/utility.list.chroot', 'doc/md/packages/utility.md' ],
	[ 'config/package-lists/network.list.chroot', 'doc/md/packages/network.md' ],
	[ 'config/package-lists/office.list.chroot', 'doc/md/packages/office.md' ] ,
	[ 'config/package-lists/graphics.list.chroot', 'doc/md/packages/graphics.md' ],
	[ 'config/package-lists/audio-video.list.chroot', 'doc/md/packages/audio-video.md' ],
	[ 'config/package-lists/system.list.chroot', 'doc/md/packages/system.md' ],
	[ 'config/package-lists/development.list.chroot', 'doc/md/packages/development.md' ],
	[ 'config/package-lists/games.list.chroot', 'doc/md/packages/games.md' ]
	]

def get_package_metadata(package):
	'''get package metadata from apt database/hardcoded URLs
	returns: list of strings'''
	print('[INFO] parsing metadata for %s' % package)
	pkg = cache[(package)]
	candidate = depcache.get_candidate_ver(pkg)
	desc = candidate.translated_description
	version = candidate.ver_str
	(f, index) = desc.file_list.pop(0)
	records = apt_pkg.PackageRecords(cache)
	records.lookup((f, index))
	short_desc = records.short_desc
	long_desc = records.long_desc.replace(' .', '')
	long_desc = re.sub(r'^[A-z].*', '', long_desc)
	long_desc = long_desc.split('\n\n')[0]
	screenshot_url = 'https://screenshots.debian.net/thumbnail-with-version/{}/{}'.format(package, version)
	pdo_url = 'https://packages.debian.org/bullseye/{}'.format(package)
	return short_desc, long_desc, screenshot_url, pdo_url, version


def package_to_markdown(package, short_desc, long_desc, screenshot_url, pdo_url, version, pkg_type):
	'''format package metdata to markdown
	returns: markdown string'''
	installed_icon = '![](green.png)'
	optional_icon = '![](grey.png)'
	if pkg_type == 'description':
		markdown = '\n</sub>\n\n<img align="right" src="{}">\n\n**[{}]({})** - {}\n\n{}\n\n<sub>\n\n-----------------------\n\n'.format(screenshot_url, package, pdo_url, short_desc, long_desc)
	elif pkg_type == 'short':
		markdown = '- {} [{}]({}) `{}` - {}'.format(installed_icon, package, pdo_url, version, short_desc)
	elif pkg_type == 'alt':
		markdown = '- {} _[{}]({}) `{}` - {}_'.format(optional_icon, package, pdo_url, version, short_desc)
	return markdown


if __name__ == "__main__":
	'''main loop'''
	apt_pkg.init()
	cache = apt_pkg.Cache()
	depcache = apt_pkg.DepCache(cache)
	package_state_key = '\n![](green.png) installed - ![](grey.png) suggested\n\n'
	for pkg_list, destination in package_lists:
		output = ''
		with open(pkg_list, 'r') as list:
			#print(pkg_list) #DEBUG
			for line in list:
				if line.startswith('#Title:'):
					list_title = line.split(' ', 1)[1].strip()
					output = output + '\n### {}\n'.format(list_title)
					output = output + package_state_key
				elif line.startswith('#Section:'):
					section_title = line.split(' ', 1)[1].strip()
					output = output + '\n#### {}\n'.format(section_title)
				if line.startswith('#Description:'):
					pkg_type = 'description'
					package = line.split(' ')[1].strip()
				elif line.startswith('#Alt'):
					pkg_type = 'alt'
					package = line.split(' ')[1].strip()
				elif re.match(r'^[0-9, A-z].*', line):
					pkg_type = 'short'
					package = line.split(' ')[0].strip()
				else:
					pkg_type = None
				if pkg_type:
					#print(package) #DEBUG
					short_desc, long_desc, screenshot_url, pdo_url, version = get_package_metadata(package)
					markdown = package_to_markdown(package, short_desc, long_desc, screenshot_url, pdo_url, version, pkg_type)
					output = output + '\n' + markdown
		with open(destination, 'w+') as out:
			out.write(output)

