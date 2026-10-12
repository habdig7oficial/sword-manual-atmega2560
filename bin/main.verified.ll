; ModuleID = 'main.ll'
source_filename = "main.ll"

%slice = type { ptr, i64 }

@str.0 = private unnamed_addr constant [35 x i8] c"panic: integer overflow at line 12\0A"
@strv.0 = private unnamed_addr constant %slice { ptr @str.0, i64 35 }

declare void @pin_up(i8)

declare void @pin_down(i8)

declare void @delay(double)

declare i32 @main()

declare i64 @write(i32, ptr, i64)

declare void @abort()

; Function Attrs: noreturn
define internal void @sword_panic(ptr %msg, i64 %len) #0 {
bb0:
  %w = call i64 @write(i32 2, ptr %msg, i64 %len)
  call void @abort()
  unreachable
}

define i8 @main.ResOne() {
bb0:
  %v1 = alloca i8, align 1
  call void @pin_up(i8 0)
  store i8 1, ptr %v1, align 1
  %v4 = load i8, ptr %v1, align 1
  %v5 = add i8 %v4, 1
  %t6 = call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 %v4, i8 1)
  %v6 = extractvalue { i8, i1 } %t6, 1
  %v7 = xor i1 %v6, true
  br i1 %v7, label %bb2, label %bb1

bb1:                                              ; preds = %bb0
  call void @sword_panic(ptr @str.0, i64 35)
  unreachable

bb2:                                              ; preds = %bb0
  store i8 %v5, ptr %v1, align 1
  %v10 = load i8, ptr %v1, align 1
  ret i8 %v10
}

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare { i8, i1 } @llvm.sadd.with.overflow.i8(i8, i8) #1

attributes #0 = { noreturn }
attributes #1 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
