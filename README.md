# editable ALV with value dependant field control

https://www.abapforum.com/forum/viewtopic.php?f=1&t=25570

![Screenshot Demo](https://user-images.githubusercontent.com/75187288/195816456-7e18f0e7-9d51-4534-be94-7b7177fc3e13.png)

Two variants to fulfill the following requirement:

A test result has to be entered in field _RESULT_.

If the result is OK then the field _REASON_ is set to display only.

If the result is NOK (Not okay) then the user has to enter a reason in field _REASON_

# Variant 1

Class main1 uses a listbox for field _RESULT_

# Variant 2

Class main2 uses free text.
After user presses TAB the value in _RESULT_ will be analyzed. If value is OK then the column _REASON_ will be set to display-only.
Glitch: if the user already entered the value OK and changes it to NOK then the ALV grid does not recognize the focus change after TAB so that column _REASON_ is not set back to editable

