; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt -S -passes=loop-idiom < %s | FileCheck %s

; Make sure that any inserted LCSSA phi nodes are removed if the transform
; is aborted.

define void @test() {
; CHECK-LABEL: define void @test() {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ALLOCA:%.*]] = alloca [64 x i8], align 16
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ 1, [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    br i1 false, label [[LOOP_EXIT2:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[OR:%.*]] = or i64 [[PHI]], 4
; CHECK-NEXT:    br i1 false, label [[LOOP_EXIT:%.*]], label [[LOOP]]
; CHECK:       loop.exit:
; CHECK-NEXT:    [[OR_LCSSA:%.*]] = phi i64 [ [[OR]], [[LOOP_LATCH]] ]
; CHECK-NEXT:    br label [[LOOP2_PREHEADER:%.*]]
; CHECK:       loop.exit2:
; CHECK-NEXT:    br label [[LOOP2_PREHEADER]]
; CHECK:       loop2.preheader:
; CHECK-NEXT:    [[PHI5_PH:%.*]] = phi ptr [ null, [[LOOP_EXIT2]] ], [ [[ALLOCA]], [[LOOP_EXIT]] ]
; CHECK-NEXT:    [[PHI6_PH:%.*]] = phi i64 [ 0, [[LOOP_EXIT2]] ], [ [[OR_LCSSA]], [[LOOP_EXIT]] ]
; CHECK-NEXT:    br label [[LOOP2:%.*]]
; CHECK:       loop2:
; CHECK-NEXT:    [[PHI5:%.*]] = phi ptr [ [[GETELEMENTPTR7:%.*]], [[LOOP2]] ], [ [[PHI5_PH]], [[LOOP2_PREHEADER]] ]
; CHECK-NEXT:    [[PHI6:%.*]] = phi i64 [ [[ADD:%.*]], [[LOOP2]] ], [ [[PHI6_PH]], [[LOOP2_PREHEADER]] ]
; CHECK-NEXT:    [[GETELEMENTPTR:%.*]] = getelementptr i8, ptr [[ALLOCA]], i64 [[PHI6]]
; CHECK-NEXT:    [[LOAD:%.*]] = load i8, ptr [[GETELEMENTPTR]], align 1
; CHECK-NEXT:    store i8 [[LOAD]], ptr [[PHI5]], align 1
; CHECK-NEXT:    [[GETELEMENTPTR7]] = getelementptr i8, ptr [[PHI5]], i64 1
; CHECK-NEXT:    [[ADD]] = add i64 [[PHI6]], 1
; CHECK-NEXT:    [[ICMP:%.*]] = icmp eq i64 [[PHI6]], 0
; CHECK-NEXT:    br i1 [[ICMP]], label [[LOOP2_EXIT:%.*]], label [[LOOP2]]
; CHECK:       loop2.exit:
; CHECK-NEXT:    ret void
;
entry:
  %alloca = alloca [64 x i8], align 16
  br label %loop

loop:
  %phi = phi i64 [ 0, %entry ], [ 1, %loop.latch ]
  br i1 false, label %loop.exit2, label %loop.latch

loop.latch:
  %or = or i64 %phi, 4
  br i1 false, label %loop.exit, label %loop

loop.exit:
  br label %loop2.preheader

loop.exit2:
  br label %loop2.preheader

loop2.preheader:
  %phi5.ph = phi ptr [ null, %loop.exit2 ], [ %alloca, %loop.exit ]
  %phi6.ph = phi i64 [ 0, %loop.exit2 ], [ %or, %loop.exit ]
  br label %loop2

loop2:
  %phi5 = phi ptr [ %getelementptr7, %loop2 ], [ %phi5.ph, %loop2.preheader ]
  %phi6 = phi i64 [ %add, %loop2 ], [ %phi6.ph, %loop2.preheader ]
  %getelementptr = getelementptr i8, ptr %alloca, i64 %phi6
  %load = load i8, ptr %getelementptr, align 1
  store i8 %load, ptr %phi5, align 1
  %getelementptr7 = getelementptr i8, ptr %phi5, i64 1
  %add = add i64 %phi6, 1
  %icmp = icmp eq i64 %phi6, 0
  br i1 %icmp, label %loop2.exit, label %loop2

loop2.exit:
  ret void
}