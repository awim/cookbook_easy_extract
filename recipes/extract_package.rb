#
# Cookbook Name:: easy_extract
# Recipe:: extract_package
#
# Copyright (C) 2016  awim / mtaqwim
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

node['archive']['list'].each do |pkg|
  archive_name = node['archive'][pkg]['location'].split(/[^\/|\\]/).last
  archive_extension = archive_name.split(/\./).last
  file_owner = node['archive'][pkg]['owner']
  file_group = node['archive'][pkg]['group']
  extract_location = node['archive'][pkg]['extract']['location']
  case archive_extension
    when 'tgz'
    when 'tar'
      execute "tar -xvf #{archive_name} -C #{extract_location}" do
        user file_owner
        group file_group
        live_stream true
      end
    when 'gz'
      execute "tar -xzvf #{archive_name} -C #{extract_location}" do
        user file_owner
        group file_group
        live_stream true
      end
    when 'zip'
    when 'gzip'
      execute "unzip #{archive_name} -d #{extract_location}" do
        user file_owner
        group file_group
        live_stream true
      end
    when 'rar'
      execute "unrar -e #{archive_name} #{extract_location}" do
        user file_owner
        group file_group
        live_stream true
      end
    else
      Chef::Log.info 'Package extention is unable to extract by system'
  end
end