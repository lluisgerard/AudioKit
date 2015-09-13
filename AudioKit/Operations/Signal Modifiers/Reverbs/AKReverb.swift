//
//  AKReverb.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka on 9/13/15.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** 8 delay line stereo FDN reverb

8 delay line stereo FDN reverb, with feedback matrix based upon physical modeling scattering junction of 8 lossless waveguides of equal characteristic impedance.
*/
@objc class AKReverb : AKParameter {

    // MARK: - Properties

    private var revsc = UnsafeMutablePointer<sp_revsc>.alloc(1)

    private var input = AKParameter()


    /** Feedback level in the range 0 to 1. 0.6 gives a good small 'live' room sound, 0.8 a small hall, and 0.9 a large hall. A setting of exactly 1 means infinite length, while higher values will make the opcode unstable. [Default Value: 0.6] */
    var feedback: AKParameter = akp(0.6) {
        didSet {
            feedback.bind(&revsc.memory.feedback)
            dependencies.append(feedback)
        }
    }

    /** Low-pass cutoff frequency. [Default Value: 4000] */
    var cutoffFrequency: AKParameter = akp(4000) {
        didSet {
            cutoffFrequency.bind(&revsc.memory.lpfreq)
            dependencies.append(cutoffFrequency)
        }
    }


    // MARK: - Initializers

    /** Instantiates the reverb with default values

    - parameter input: Input audio signal. 
    */
    init(input sourceInput: AKParameter)
    {
        super.init()
        input = sourceInput
        setup()
        dependencies = [input]
        bindAll()
    }

    /** Instantiates the reverb with all values

    - parameter input: Input audio signal. 
    - parameter feedback: Feedback level in the range 0 to 1. 0.6 gives a good small 'live' room sound, 0.8 a small hall, and 0.9 a large hall. A setting of exactly 1 means infinite length, while higher values will make the opcode unstable. [Default Value: 0.6]
    - parameter cutoffFrequency: Low-pass cutoff frequency. [Default Value: 4000]
    */
    convenience init(
        input           sourceInput:   AKParameter,
        feedback        feedbackInput: AKParameter,
        cutoffFrequency lpfreqInput:   AKParameter)
    {
        self.init(input: sourceInput)
        feedback        = feedbackInput
        cutoffFrequency = lpfreqInput

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal reverb */
    internal func bindAll() {
        feedback       .bind(&revsc.memory.feedback)
        cutoffFrequency.bind(&revsc.memory.lpfreq)
        dependencies.append(feedback)
        dependencies.append(cutoffFrequency)
    }

    /** Internal set up function */
    internal func setup() {
        sp_revsc_create(&revsc)
        sp_revsc_init(AKManager.sharedManager.data, revsc)
    }

    /** Computation of the next value */
    override func compute() {
        sp_revsc_compute(AKManager.sharedManager.data, revsc, &(input.leftOutput), &(input.rightOutput), &leftOutput, &rightOutput);
    }

    /** Release of memory */
    override func teardown() {
        sp_revsc_destroy(&revsc)
    }
}