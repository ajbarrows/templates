from pathlib import Path


def test_proj_root_exists():
    """Verify the project root path is correctly resolved."""
    from project_name.config import PROJ_ROOT

    assert isinstance(PROJ_ROOT, Path)
    assert PROJ_ROOT.exists()
