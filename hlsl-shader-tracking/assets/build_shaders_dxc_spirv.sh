#!/bin/sh

# echo on
set -x

# Create temporary build dir
build_dir=tmp_build
mkdir -p $build_dir

# @fn spirv_opt
#
#
function process_spv()
{
  set -x
  spv_file=$1

  spirv-opt \
  --inline-entry-points-exhaustive \
  --convert-local-access-chains \
  --eliminate-local-single-block \
  --eliminate-local-single-store \
  --eliminate-insert-extract \
  --eliminate-dead-code-aggressive \
  --eliminate-dead-branches \
  --merge-blocks \
  --eliminate-local-single-block \
  --eliminate-local-single-store \
  --eliminate-local-multi-store \
  --eliminate-insert-extract \
  --eliminate-dead-code-aggressive \
  --eliminate-common-uniform \
  -o $build_dir/$spv_file.tmp_1 $spv_file
  
  spirv-opt -Os -o $spv_file $build_dir/$spv_file.tmp_1 
}

# @fn disassemble_spv
#
#
function disassemble_spv()
{
  spv_file=$1
  asm_file=$2
  spirv-dis --raw-id $spv_file > $asm_file
}

# structs_01
file=structs_01
dxc -spirv -T vs_6_0 -E vsmain -Fo $file.vs.spv $file.hlsl
dxc -spirv -T ps_6_0 -E psmain -Fo $file.ps.spv $file.hlsl

# structs_02
file=structs_02
dxc -spirv -T vs_6_0 -E vsmain -Fo $file.vs.spv $file.hlsl
dxc -spirv -T ps_6_0 -E psmain -Fo $file.ps.spv $file.hlsl