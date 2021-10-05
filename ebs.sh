#! /bin/bash
mkfs -t xfs /dev/xvdb
mkdir /mxlocal
mount /dev/xvdb /mxlocal
blkid /dev/xvdb |  awk '{print $2}' > /tmp/mx_tmpb_fsfile
sed -i 's/"//' /tmp/mx_tmpb_fsfile
sed -i 's/"/ \/mxlocal  xfs     defaults        0 0 /' /tmp/mx_tmpb_fsfile
cat /tmp/mx_tmpb_fsfile >> /etc/fstab
mkfs -t xfs /dev/xvdh
mkdir /mxdata
mount /dev/xvdh /mxdata
blkid /dev/xvdh |  awk '{print $2}' > /tmp/mx_tmph_fsfile
sed -i 's/"//' /tmp/mx_tmph_fsfile
sed -i 's/"/ \/mxdata  xfs     defaults        0 0 /' /tmp/mx_tmph_fsfile
cat /tmp/mx_tmph_fsfile >> /etc/fstab
