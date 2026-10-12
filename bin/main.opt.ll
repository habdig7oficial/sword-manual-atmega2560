; ModuleID = 'main.verified.ll'
source_filename = "main.ll"

declare void @pin_up(i8) local_unnamed_addr

declare void @delay(double) local_unnamed_addr

define noundef i8 @main.ResOne() local_unnamed_addr {
bb0:
  tail call void @pin_up(i8 0)
  tail call void @delay(double 1.000000e+03)
  tail call void @delay(double 1.000000e+03)
  ret i8 2
}
