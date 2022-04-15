from isar_db.mongo_interface import isar_db
from isar_db.isar_db_model import Models, get_model_string
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import make_axes_locatable
import numpy as np
from libISAR.rdi import dotdict
from isar_db.isar_db_model import decode_numpy


json_to_img = lambda entry: np.array(decode_numpy(entry)["array"])


# hard coding this due to lack of time left in project
ids = (
    ()
)
def plot_image(ax, fig, img: np.ndarray, bounds, title: str):

    plt.rcParams.update({'font.size': 12, 'font.weight': 'bold', 'font.family': 'Arial'})
    divider = make_axes_locatable(ax)
    cax = divider.append_axes('right', size='5%', pad=0.05)

    dB = [-60, 10]

    im = ax.imshow(img,
                   cmap="viridis",
                   extent=[bounds.cross_range[0], bounds.cross_range[1], bounds.rel_range[0], bounds.rel_range[1]],
                   vmin=dB[0], vmax=dB[1])

    ax.set_aspect('auto')
    ax.set_title(title)
    ax.set_xlabel("Cross Range (m)")
    ax.set_ylabel("Relative Range (m)")

    fig.colorbar(im, cax=cax, orientation='vertical')

def get_img_from_query(kappa, theta, snr, model_id):

    mongodb = isar_db()

    q_dict = {
        "model_label": model_id,
        "kappa_label": kappa,
        "theta_label": theta,
        "SNR": snr
    }

    doc = mongodb.img_data_col.find_one(q_dict)

    pid = doc["parent_doc_id"]
    img = json_to_img(doc["img"])

    bounds = dotdict({
        "cross_range" : (doc["crossRangeStart"], doc["crossRangeStop"]),
        "rel_range" : (doc["relRangeStart"], doc["relRangeStop"])
    })

    return pid, img, bounds


def get_file_listing(pid):
    mongodb = isar_db()

    doc = mongodb.signature_col.find_one({'_id': pid})
    return doc["hwb_filename"]

def get_wsu_report_plot_data():
    imgs = {}
    hwb_files = []
    for model in Models:
        imgs[model] = {"theta_60_kappa_90": None, "theta_90_kappa_90": None, "theta_90_kappa_90_noise": None}

        pid, img, bounds = get_img_from_query(90, 60, 0, model.value)
        hwb_path = get_file_listing(pid)
        hwb_files.append(hwb_path)
        print("hwb reference image for Model: ", model, " and Kappa: 90  Theta: 60 -> ", hwb_path)
        imgs[model]["theta_60_kappa_90"] = (img, bounds)

        pid, img, bounds = get_img_from_query(90, 90, 0, model.value)
        hwb_path = get_file_listing(pid)
        hwb_files.append(hwb_path)
        print("hwb reference image for Model: ", model, " and Kappa: 90  Theta: 90 -> ", hwb_path)
        imgs[model]["theta_90_kappa_90"] = (img, bounds)

        pid, img, bounds = get_img_from_query(90, 90, 30, model.value)
        hwb_path = get_file_listing(pid)
        hwb_files.append(hwb_path)
        print("hwb reference image for Model (Noisy): ", model, " and Kappa: 90  Theta: 90 -> ", hwb_path)
        imgs[model]["theta_90_kappa_90_noise"] = (img, bounds)

    return dotdict(imgs), hwb_files

def create_report_plots(img_data: dotdict):

    for model_key, dataset in img_data.items():
        title = "Sample ISAR ECP Images for " + get_model_string(model_key) + " CAD Model"
        fig, (ax1, ax2, ax3) = plt.subplots(1, 3)
        fig.suptitle(title)

        img1 = dataset["theta_90_kappa_90"][0]
        bounds1 = dataset["theta_90_kappa_90"][1]

        plot_image(ax1, fig, img1, bounds1, "Pure Tumble")

        img2 = dataset["theta_90_kappa_90_noise"][0]
        bounds2 = dataset["theta_90_kappa_90_noise"][1]

        plot_image(ax2, fig, img2, bounds2, "Pure Tumble with Noise")

        img3 = dataset["theta_60_kappa_90"][0]
        bounds3 = dataset["theta_60_kappa_90"][1]

        plot_image(ax3, fig, img3, bounds3, "Precession Motion")

        plt.show()


if __name__ == "__main__":

    img_data, hwb_files = get_wsu_report_plot_data()
    create_report_plots(img_data)



