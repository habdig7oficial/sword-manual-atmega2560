; ModuleID = 'main.verified.ll'
source_filename = "main.ll"

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define noundef i8 @main.ResOne() local_unnamed_addr #0 {
bb0:
  ret i8 1
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
