#!/usr/bin/env bash

# Author: RayZ0rr (github.com/RayZ0rr)
#
# Dependencies:
# - dmenu     : Selection menu
# - rofi      : nice dmenu alternative
# - zenity     : Selection prompt
# - fgrep+sed ...

layoutFolder="${HOME}/.config/i3/layouts"
prompt=`zenity --entry --title="Select operation mode" --text="('save' or 'load'):" --entry-text "save"`
! [[ -d "${layoutFolder}" ]] && mkdir -p "${layoutFolder}"

if [[ "$prompt" == "save" ]] ; then

  name=`zenity --entry --title="Save the current Layout to ${layoutFolder}" --text="Enter name of new Layout:" --entry-text "NewLayout.json"`
  nameFull="${layoutFolder}/${name}"
  property=`zenity --entry --title="Property to use for swallow" --text="('class','instance','title' or 'all')" --entry-text "class"`

  if ! [[ -z "${name}" ]] ; then

    if [[ "${property}" == "class" ]] ; then

      i3-save-tree > "${nameFull}"
      # Remove comma at the end class
      fgrep -v '// split' "${nameFull}" | sed -i '/"class"/s|,$||g' "${nameFull}"
      # Remove // at the beginning class
      fgrep -v '// split' "${nameFull}" | sed -i 's|//\ "class|"class|g' "${nameFull}"

    elif [[ "${property}" == "instance" ]] ; then

      i3-save-tree > "${nameFull}"
      # Remove comma at the end instance
      fgrep -v '// split' "${nameFull}" | sed -i '/"instance"/s|,$||g' "${nameFull}"
      # Remove // at the beginning instance
      fgrep -v '// split' "${nameFull}" | sed -i 's|//\ "instance|"instance|g' "${nameFull}"

    elif [[ "${property}" == "title" ]] ; then

      i3-save-tree > "${nameFull}"
      # Remove // at the beginning title
      fgrep -v '// split' "${nameFull}" | sed -i 's|//\ "title|"title|g' "${nameFull}"

    elif [[ "${property}" == "all" ]] ; then

      i3-save-tree > "${nameFull}"
      fgrep -v '// split' "${nameFull}" | sed -i 's|//\ "class|"class|g' "${nameFull}"
      fgrep -v '// split' "${nameFull}" | sed -i 's|//\ "instance|"instance|g' "${nameFull}"
      fgrep -v '// split' "${nameFull}" | sed -i 's|//\ "title|"title|g' "${nameFull}"

    else
      exit 1
    fi

  else
    exit 1
  fi

elif [[ "$prompt" == "load" ]] ; then

  name=`ls ${layoutFolder}/ | dmenu -p "Choose a Layout" -i -l 11`
  i3-msg append_layout ${layoutFolder}/${name} >> ${layoutFolder}/output.log

else
  exit 1
fi

