// *********************************************************************
// *              Copyright (c) 2005-2010 Synopsys, Inc.               *
// *                                                                   *
// * This software and the associated documentation are confidential   *
// * and proprietary to Synopsys, Inc. Your use or disclosure of this  *
// * software is subject to the terms and conditions of a written      *
// * license agreement between you, or your company, and Synopsys, Inc.*
// *********************************************************************/

#ifndef TLI_PACKUNPACK_my_payload_H
#define TLI_PACKUNPACK_my_payload_H

#include "tli_packunpack.h"
#include "/remote/vtghome11/subhaa/p4_11_12/unit_Examples/vcs/uvm/simple/tlm2/systemC/user/payload.h"

template <typename T> void tli_conv2_pack_tlmgp(tli_pack_data&, T&);
template <typename T> void tli_conv2_unpack_tlmgp(tli_pack_data&, T&);
void tli_conv2_pack_my_payload(tli_pack_data& P, const my_payload& my_payload_obj);
void tli_conv2_unpack_my_payload(tli_pack_data& P, my_payload& my_payload_obj);

#endif
