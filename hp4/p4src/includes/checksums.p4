/*
David Hancock
FLUX Research Group
University of Utah
dhancock@cs.utah.edu

HyPer4: A P4 Program to Run Other P4 Programs

checksums.p4: Implements checksums.
*/

/*
action a_ipv4_csum16(rshift_base, div) {
  modify_field(csum.rshift, rshift_base);
  modify_field(csum.div, div);
  // dst low
  modify_field(csum.sum, ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + csum.div);
  // dst high
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + csum.div);
  // src low
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + csum.div);
  // src high
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + csum.div);
  // skip csum
  modify_field(csum.rshift, csum.rshift + csum.div);
  // TTL+protocol
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + csum.div);
  // flags+frag offset
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + csum.div);
  // ID
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + csum.div);
  // totalLen
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + csum.div);
  // version+IHL+DSCP
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  
  // add carry
  modify_field(csum.sum, (csum.sum + (csum.sum >> csum.div)) & 0xFFFF);

  // invert and store
  modify_field(csum.final, ~csum.sum);

  modify_field(csum.csmask, 0xFFFF << 304);
  modify_field(extracted.data, (extracted.data & ~csum.csmask) | ((csum.final << 304) & csum.csmask));
}
*/

action a_ipv4_csum16(rshift_base) {
  modify_field(csum.rshift, rshift_base);
  // dst low
  modify_field(csum.sum, ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + 16);
  // dst high
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + 16);
  // src low
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + 16);
  // src high
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + 16);
  // skip csum
  modify_field(csum.rshift, csum.rshift + 16);
  // TTL+protocol
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + 16);
  // flags+frag offset
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + 16);
  // ID
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + 16);
  // totalLen
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  modify_field(csum.rshift, csum.rshift + 16);
  // version+IHL+DSCP
  modify_field(csum.sum, csum.sum + ((extracted.data >> csum.rshift) & 0xFFFF));
  
  // add carry
  modify_field(csum.sum, (csum.sum + (csum.sum >> 16)) & 0xFFFF);

  // invert and store
  modify_field(csum.final, ~csum.sum);

  // shouldn't it be 576 instead of 304?
  modify_field(csum.csmask, 0xFFFF << 400);
  modify_field(extracted.data, (extracted.data & ~csum.csmask) | ((csum.final << 400) & csum.csmask));
}

table csum16 {
  reads {
    meta_ctrl.program : exact;
    // TODO: extracted.validbits : ternary
  }
  actions {
    a_ipv4_csum16;
    _no_op;
  }
}
