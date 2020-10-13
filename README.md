
# UIDTools
UIDTool and GUIDTool generate's Apple `UniqueID` and `GeneratedUID` for users from the user's Active Directory base64 `ObjectGUID` respectively.  This is built for NoMAD Login AD's `UIDTool` and `GUIDTool` facility. 

* Both rely on a version of the python script [guid-tool](https://github.com/danielgtaylor/guid-tool). The version in this repo runs in Apple's Python 2.7 and is updated for Python 3. My minor 2to3 changes to the script can be found [here](https://github.com/PeetMcK/guid-tool).

* Both rely on a version of the perl script [cldap.pl](https://github.com/samba-team/samba/blob/master/examples/misc/cldap.pl) from the [SAMBA](https://github.com/samba-team/samba) project. The version in this repo is lovingly hacked to simply test a DC and respond if it's the closest DC or not, 1 or 0 respectively.
