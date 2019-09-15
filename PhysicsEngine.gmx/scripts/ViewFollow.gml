#define ViewFollow

#define ViewFollowSetup
///ViewFollowSetup() sets up the logic for the view to follow this object.
view_enabled = true
view_visible[0] = true
view_hspeed[0] = 1000
view_vspeed[0] = 1000

#define ViewFollowEndStep
///ViewFollowEndStep() runs the step logic for the view to follow this object.
view_xview[0] = floor(x)-view_wview[0]/2
view_yview[0] = floor(y)-view_hview[0]/2
