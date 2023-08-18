`ifndef TCNT_AXI_DEC__SV
`define TCNT_AXI_DEC__SV

package tcnt_axi_dec;
    
    typedef enum bit [2:0]{
        READ      = 0,
        WRITE     = 1
    } xact_type_enum;
    /**
    * Enum to represent transfer sizes
    */
    typedef enum bit [3:0] {
      BURST_SIZE_8BIT    = 0, 
      BURST_SIZE_16BIT   = 1, 
      BURST_SIZE_32BIT   = 2, 
      BURST_SIZE_64BIT   = 3, 
      BURST_SIZE_128BIT  = 4, 
      BURST_SIZE_256BIT  = 5, 
      BURST_SIZE_512BIT  = 6, 
      BURST_SIZE_1024BIT = 7, 
      BURST_SIZE_2048BIT = 8 
    } burst_size_enum;

    /**
     * Enum to represent burst type in a transaction
     */
    typedef enum bit[1:0]{
      FIXED = 0,
      INCR  = 1,  
      WRAP  = 2
    } burst_type_enum;
    
    /**
     * Enum to represent locked type in a transaction
     */
    
    typedef enum bit [2:0] {
      DATA_SECURE_NORMAL                = 0, 
      DATA_SECURE_PRIVILEGED            = 1,     
      DATA_NON_SECURE_NORMAL            = 2,     
      DATA_NON_SECURE_PRIVILEGED        = 3,     
      INSTRUCTION_SECURE_NORMAL         = 4,     
      INSTRUCTION_SECURE_PRIVILEGED     = 5,      
      INSTRUCTION_NON_SECURE_NORMAL     = 6,     
      INSTRUCTION_NON_SECURE_PRIVILEGED = 7    
    } prot_type_enum;

      /**
     * Enum to represent responses in a transaction
     */
    typedef enum bit [1:0] {
      OKAY    = 0, 
      EXOKAY  = 1, 
      SLVERR  = 2, 
      DECERR  = 3 
    } resp_type_enum;
    
    /**
    * Enum to represent locked type in a transaction
    */
    typedef enum bit [1:0] {
      NORMAL     = 0, 
      EXCLUSIVE  = 1, 
      LOCKED     = 2 
    } atomic_type_enum;
    
    /**
   *  Enum for interleave block pattern
   */

  typedef enum {
    EQUAL_BLOCK   = 0, 
    RANDOM_BLOCK  = 1 
  } interleave_pattern_enum;

    /** 
   * Enum to represent the Endianness of the outbound write data sent in Atomic transactions.
   * Following are the possible values:
   * - LITTLE_ENDIAN : Indicates that the outbound Atomic Write data is in the Little Endian format
   * - BIG_ENDIAN    : Indicates that the outbound Atomic Write data is in the Big Endian format
   * .
   */
  typedef enum {
    LITTLE_ENDIAN       =  0,
    BIG_ENDIAN          =  1
  } endian_enum;

   /**
   *  @groupname axi3_4_status
   *  Represents the current status of the read or write address.  Following are the
   *  possible status types.

   * - INITIAL               : Address phase has not yet started on the channel
   * - ACTIVE                : Address valid is asserted but ready is not 
   * - ACCEPT                : Address phase is complete 
   * - ABORTED               : Current transaction is aborted
   * .
   */
  typedef enum bit [2:0]{
    INITIAL        = 0,
    ACTIVE         = 1,
    PARTIAL_ACCEPT = 2,
    ACCEPT         = 3, 
    ABORTED        = 4
  } status_enum;
  /** Enumerated types that identify the type of the AXI interface. */
    typedef enum {
        AXI3        = 0,
        AXI4        = 1,
        AXI4_LITE   = 2
    } axi_interface_type_enum;

  /**
    * Enumerated typed for the port kind
    */    
    typedef enum {
        AXI_MASTER = 0,
        AXI_SLAVE  = 1
    } axi_port_kind_enum;

    /**
     * Enumerated type that indicates the reordering algorithm 
     * used for ordering the transactions or responses.
     */
    typedef enum {
        ROUND_ROBIN     = 0, /**< Transactions will be 
        processed in the order they are received. */
        RANDOM          =  1, /**< Transactions will be 
        processed in any random order, irrespective of the order they are received. */
        PRIORITIZED     = 2/**< Transactions will be
        processed in a prioritized order. The priority of a transaction is known from
        the tcnt_axi_transaction::reordering_priority attribute of that transaction. */
    } reordering_algorithm_enum;

    /**
     * Enumerated type that indicates how the reordering depth 
     * of transactions moves.
     * 
     * Example:
     * Consider the read data reordering depth of 2; R1, R2, R3 and R4 are the read
     * transactions to be responded. The behavior for different types reordering depth
     * is as follows:
     * - STATIC:
     *   Once both R1 and R2 are complete, then only the reordering depth moves:
     *   {R1, R2} -- to --> {R3, R4}
     * - MOVING:
     *   If any of the R1 or R2 is complete, then the reordering depth moves. Suppose
     *   that R2 is complete before R1. Then the reordering depth window moves as:
     *   {R1, R2} -- to --> {R1, R3}
     * .
     */
    typedef enum {
        STATIC         = 0, /**< The reordering depth moves
        when all transactions within the current reordering depth are complete. */
        MOVING         = 1  /**< A new transaction is considered
        for access to send read data as part of the given reordering depth when any transaction
        within the current reordering depth is complete. */
    } reordering_window_enum;

    /** @cond PRIVATE */
    /**
      * Enumerated type for the kind of inactivity period for throughput calculation
      */
    typedef enum {
        EXCLUDE_ALL = 0,
        EXCLUDE_BEGIN_END = 1
    } perf_inactivity_algorithm_type_enum;
    /** @endcond */

endpackage:tcnt_axi_dec

import tcnt_axi_dec::*;

`endif

