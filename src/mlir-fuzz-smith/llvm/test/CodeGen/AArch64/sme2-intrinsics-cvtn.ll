; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sme2,+bf16 -verify-machineinstrs < %s | FileCheck %s

;
; FCVTN
;
define <vscale x 8 x half> @multi_vector_cvtn_x2_f16(<vscale x 4 x float> %zn1, <vscale x 4 x float> %zn2) {
; CHECK-LABEL: multi_vector_cvtn_x2_f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $z1 killed $z1 killed $z0_z1 def $z0_z1
; CHECK-NEXT:    // kill: def $z0 killed $z0 killed $z0_z1 def $z0_z1
; CHECK-NEXT:    fcvtn z0.h, { z0.s, z1.s }
; CHECK-NEXT:    ret
  %res = call <vscale x 8 x half> @llvm.aarch64.sve.fcvtn.x2.nxv4f32(<vscale x 4 x float> %zn1, <vscale x 4 x float> %zn2)
  ret <vscale x 8 x half> %res
}

;
; BFCVTN
;

define <vscale x 8 x bfloat> @multi_vector_bfcvtn_x2(<vscale x 4 x float> %zn1, <vscale x 4 x float> %zn2) {
; CHECK-LABEL: multi_vector_bfcvtn_x2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $z1 killed $z1 killed $z0_z1 def $z0_z1
; CHECK-NEXT:    // kill: def $z0 killed $z0 killed $z0_z1 def $z0_z1
; CHECK-NEXT:    bfcvtn z0.h, { z0.s, z1.s }
; CHECK-NEXT:    ret
  %res = call <vscale x 8 x bfloat> @llvm.aarch64.sve.bfcvtn.x2(<vscale x 4 x float> %zn1, <vscale x 4 x float> %zn2)
  ret <vscale x 8 x bfloat> %res
}

declare <vscale x 8 x half> @llvm.aarch64.sve.fcvtn.x2.nxv4f32(<vscale x 4 x float>, <vscale x 4 x float>)
declare <vscale x 8 x bfloat> @llvm.aarch64.sve.bfcvtn.x2(<vscale x 4 x float>, <vscale x 4 x float>)