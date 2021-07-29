package com.funidea.newonpe.network

interface OnAttachmentDownloadListener
{
    fun onAttachmentDownloadedSuccess()
    fun onAttachmentDownloadedError()
    fun onAttachmentDownloadedFinished()
    fun onAttachmentDownloadUpdate(percent: Int)
}