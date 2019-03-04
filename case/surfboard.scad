$fn = 100;

$unit = 19.05;
$100mil = 2.54;

$pcb_grid   = 0.297658;
$kadomaru_r = $pcb_grid * 12;

// ---- screw hole size
$screw_hole = (2 + 0.1) / 2;

// ---- top plate placements
$switch_hole = 14;

// ---- bottom plate placements
$slop = 1;
$promicro_height = 13 * $100mil + $slop / 2;
$promicro_width  = 7 * $100mil + $slop;
// TVBP06-B043CB-B
$reset_height = 3.5 + $slop;
$reset_width  = 6 + $slop;

module kadomaru () {
  offset (r = $kadomaru_r) children();
}

module skrewed (left = false) {
  difference () {
    children();
    for (x = [0.5 * $unit, 2.5 * $unit])
      for (y = [0, 2 * $unit])
        translate ([x, y])
          circle(r = $screw_hole);
  }
}

module topplate (left = false) {
  skrewed(left) difference () {
    kadomaru () 
      square([$unit * 3, $unit * 2]);
    // switches
    for (x = [0, 1, 2])
      for (y = [0, 1])
        translate([(x + 0.5) * $unit, (y + 0.5) * $unit])
          square([$switch_hole, $switch_hole], center = true);
  }
}

module bottomplate (left = false) {
  skrewed(left) difference () {
    kadomaru()
      square([$unit * 3, $unit * 2]);
    // promicro
   translate([1.5 * $unit, 2 * $unit + $kadomaru_r - $promicro_height / 2])
      square([$promicro_width, $promicro_height], center = true);
    // reset sw
    translate([2 * $unit - $slop / 2, $unit - $reset_width / 2])
      square([$reset_height, $reset_width]);
  }
}

module single_keycap_preview () {
  hull () {
    linear_extrude(0.001) offset(r = 1) offset(r = -1) square([18.5, 18.5], center = true);
    translate([0, 0, 8]) linear_extrude(0.001) offset(r = 2) offset(r = -2) square([14, 14], center = true);
  }
}

module single_spacer_preview () {
  $fn = 6;
  cylinder(d = 5, h = 7);
}

module keycap_preview () {
  for (y = [0, 1])
    for (x = [0, 1, 2])
      translate([(x + 0.5) * $unit, (y + 0.5) * $unit])
        single_keycap_preview();
}

module spacer_preview () {
  for (x = [0.5 * $unit, 2.5 * $unit])
    for (y = [0, 2 * $unit])
      translate ([x, y])
        single_spacer_preview();
}

module pcb_preview () {
  kadomaru () {
    square([$unit * 3, $unit * 2]);
  }
}

// Use FreeCAD "KiCad STEP UP" plugin to generate .stl from a .kicad_pcb.
// Note that you may need to fix the path to the .3dshapes directory.
module pcb_preview_kicad (left = false) {
  translate([0, 2 * $unit, 1.6]) import("../pcb/surfboard.stl");
}

module preview () {
  translate([0, 0, 18.8])
    color([0.6, 0.6, 0.8])
      keycap_preview();
  translate([0, 0, 9.1])
    color([1, 1, 1, 0.3])
      linear_extrude(3) topplate();
//  translate([0, 0, 5.5])
//    color([1, 1, 1])
//      linear_extrude(1.6) pcb_preview();
  translate([0, 0, 5.5])
    color([1, 1, 1])
      pcb_preview_kicad();
  translate([0, 0, 3])
    color([0.8, 0.8, 0.5])
      spacer_preview();
  color([1, 1, 1, 0.3])
    linear_extrude(3) bottomplate();
}

module cut_model_100x100 (guide = false) {
  difference () {
    if (guide) square([100, 100]);
    translate([3, 3]) {
      translate([$kadomaru_r, $kadomaru_r]) topplate();
      translate([$kadomaru_r, $kadomaru_r * 3 + 2 * $unit + 3]) bottomplate();
    }
  }
}

module cut_model_300x300 (guide = false) {
  difference () {
    if (guide) square([300, 300]);
    translate([3, 3]) {
        for (y = [0, 1, 2]) {
        for (x = [0, 1, 2, 3]) {
          translate ([($kadomaru_r * 3 + 3 * $unit) * x, ($kadomaru_r * 4 + 4 * $unit + 6) * y]) {
            translate([$kadomaru_r, $kadomaru_r]) topplate();
            translate([$kadomaru_r, $kadomaru_r * 3 + 2 * $unit + 3]) bottomplate();
          }
        }
      }
    }
  } 
}

//cut_model_100x100(true);
preview();
//pcb_preview_kicad();
