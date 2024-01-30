; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 3
; RUN: opt -passes=newgvn -S < %s | FileCheck %s

@c = global i32 0, align 4

; Function Attrs: nounwind optsize uwtable
define i32 @main(i1 %cond1, i32 %arg0, i32 %arg1) {
; CHECK-LABEL: define i32 @main(
; CHECK-SAME: i1 [[COND1:%.*]], i32 [[ARG0:%.*]], i32 [[ARG1:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND1]], label [[BB1:%.*]], label [[BB3:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[XOR1:%.*]] = xor i32 [[ARG0]], 1
; CHECK-NEXT:    [[COND2:%.*]] = icmp eq i32 [[ARG1]], 0
; CHECK-NEXT:    br i1 [[COND2]], label [[BB3]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[COND3:%.*]] = icmp ne i32 [[XOR1]], 0
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[COND3]])
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32 [ undef, [[ENTRY:%.*]] ], [ [[XOR1]], [[BB1]] ], [ [[XOR1]], [[BB2]] ]
; CHECK-NEXT:    [[XOR2:%.*]] = xor i32 [[PHI]], -1
; CHECK-NEXT:    [[LD:%.*]] = load i32, ptr @c, align 4
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[LD]], [[XOR2]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[OR]], 0
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[PHI]], 0
; CHECK-NEXT:    [[COND4:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    br i1 [[COND4]], label [[EXIT1:%.*]], label [[EXIT2:%.*]]
; CHECK:       exit1:
; CHECK-NEXT:    ret i32 0
; CHECK:       exit2:
; CHECK-NEXT:    ret i32 1
;
entry:
;    entry
;     / |
;   bb1 |
;   / | |
; bb2 | |
;    \| |
;     bb3
;     / \
; exit1 exit2
  br i1 %cond1, label %bb1, label %bb3

bb1:                                          ; preds = %entry
  %xor1 = xor i32 %arg0, 1
  %cond2 = icmp eq i32 %arg1, 0
  br i1 %cond2, label %bb3, label %bb2

bb2:                                          ; preds = %bb1
  %cond3 = icmp ne i32 %xor1, 0
  tail call void @llvm.assume(i1 %cond3)
  br label %bb3

bb3:                                          ; preds = %bb2, %bb1, %entry
  %phi = phi i32 [ undef, %entry ], [ %xor1, %bb1 ], [ %xor1, %bb2 ]
  %xor2 = xor i32 %phi, -1
  %ld = load i32, ptr @c, align 4
  %or = or i32 %ld, %xor2
  %cmp1 = icmp eq i32 %or, 0
  %cmp2 = icmp eq i32 %phi, 0
  %cond4 = or i1 %cmp1, %cmp2
  br i1 %cond4, label %exit1, label %exit2

exit1:                                        ; preds = %bb3
  ret i32 0

exit2:                                        ; preds = %bb3
  ret i32 1
}

declare void @llvm.assume(i1 noundef)