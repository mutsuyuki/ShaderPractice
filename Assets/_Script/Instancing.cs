using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Instancing : MonoBehaviour
{
    [SerializeField] private Mesh _mesh;
    [SerializeField] private Material _material;
    private Matrix4x4[] _matrix = new Matrix4x4[1023];

    void Start()
    {
        for (int i = 0; i < 1023; i++)
        {
            _matrix[i] = Matrix4x4.TRS(
                new Vector3(
                    Random.Range(-200f, 200f),
                    Random.Range(-200f, 200f),
                    Random.Range(-200f, 200f)
                ),
                Quaternion.identity,
                Vector3.one * 2.0f
            );
        }
    }

    void Update()
    {
        Graphics.DrawMeshInstanced(_mesh, 0, _material, _matrix);
    }
}