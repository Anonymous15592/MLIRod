; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 3
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

; Make sure we don't crash.

@j = internal constant i32 4

define void @y() {
; CHECK-LABEL: define void @y() {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND_I:%.*]]
; CHECK:       for.cond.i:
; CHECK-NEXT:    br i1 false, label [[FOR_COND_I]], label [[FOR_COND5_PREHEADER_I:%.*]]
; CHECK:       for.cond1.loopexit.i:
; CHECK-NEXT:    store i1 true, ptr poison, align 1
; CHECK-NEXT:    br i1 poison, label [[FOR_COND_I]], label [[FOR_COND5_PREHEADER_I]]
; CHECK:       for.cond5.preheader.i:
; CHECK-NEXT:    br i1 false, label [[FOR_INC19_I:%.*]], label [[FOR_COND1_LOOPEXIT_I:%.*]]
; CHECK:       for.inc19.i:
; CHECK-NEXT:    br i1 false, label [[FOR_INC19_I]], label [[FOR_COND1_LOOPEXIT_I]]
;
entry:
  br label %for.cond.i

for.cond.i:                                       ; preds = %for.cond1.loopexit.i, %for.cond.i, %entry
  %phi1 = phi ptr [ @j, %entry ], [ @j, %for.cond.i ], [ null, %for.cond1.loopexit.i ]
  %load1 = load i32, ptr %phi1, align 4
  br i1 false, label %for.cond.i, label %for.cond5.preheader.i

for.cond1.loopexit.i:                             ; preds = %for.inc19.i, %for.cond5.preheader.i
  %load2 = load i32, ptr null, align 4
  %conv.i = sext i32 %load2 to i64
  %tobool4.not.i = icmp eq i64 0, %conv.i
  br i1 %tobool4.not.i, label %for.cond.i, label %for.cond5.preheader.i

for.cond5.preheader.i:                            ; preds = %for.cond1.loopexit.i, %for.cond.i
  %phi = phi i32 [ 0, %for.cond1.loopexit.i ], [ %load1, %for.cond.i ]
  %sub6.i = or i32 %load1, 1
  %cmp5.i.i = icmp sgt i32 %load1, 41
  %a.1.3.i.i = select i1 %cmp5.i.i, i32 %sub6.i, i32 0
  %add.4.i.i = add i32 %a.1.3.i.i, 1
  %cmp8.4.i.i = icmp sgt i32 %a.1.3.i.i, 0
  %spec.select.4.i.i1 = select i1 %cmp8.4.i.i, i32 %add.4.i.i, i32 0
  %cmp11.4.i.i = icmp eq i32 %add.4.i.i, 0
  %add.5.i.i = or i32 %add.4.i.i, %sub6.i
  %cmp8.5.i.i = icmp sgt i32 %add.5.i.i, 0
  %sel = select i1 %cmp5.i.i, i1 %cmp8.5.i.i, i1 false
  %i.1.5.i.i = select i1 %sel, i32 0, i32 %spec.select.4.i.i1
  %spec.select = select i1 %cmp11.4.i.i, i32 0, i32 %i.1.5.i.i
  %add8.i = or i32 %spec.select, -1020499714
  %cmp.i3 = icmp sgt i32 %add8.i, -1020499638
  br i1 %cmp.i3, label %for.inc19.i, label %for.cond1.loopexit.i

for.inc19.i:                                      ; preds = %for.inc19.i, %for.cond5.preheader.i
  br i1 %sel, label %for.inc19.i, label %for.cond1.loopexit.i

; uselistorder directives
  uselistorder i32 %load1, { 1, 0, 2 }
}