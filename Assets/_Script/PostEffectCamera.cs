using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostEffectCamera : MonoBehaviour
{
    [SerializeField] private Material material;

    void OnRenderImage(RenderTexture __src, RenderTexture __dest)
    {
        Graphics.Blit(__src, __dest, material);
    }
}