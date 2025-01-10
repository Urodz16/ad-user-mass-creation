# Troubleshooting Guide

---

## Deleting Protected OUs
Enable Advanced Features:
- Open Active DirectoryUSers and Computers on the DC.
- In the menu bar, click View -> Advanced Features.

Locate the OU:
- Navigate to the OU you want to delete (e.g. OU=IT)

Remove Protection:
- Right-click the OU -> Properties -> Object tab.
- Uncheck Protect object from accidental deletion.
- Click OK to save the changes.

Delete the OU:
- Right-click the OU and select Delete.
- Confirm the deletion.

---