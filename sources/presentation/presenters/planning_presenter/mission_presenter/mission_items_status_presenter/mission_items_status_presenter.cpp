#include "mission_items_status_presenter.h"

// Qt
#include <QVariant>
#include <QDebug>

// Internal
#include "service_registry.h"
#include "mission_service.h"

#include "mission.h"
#include "mission_item.h"

using namespace presentation;

class MissionItemsStatusPresenter::Impl
{
public:
    domain::MissionService* service = domain::ServiceRegistry::missionService();

    dao::MissionPtr mission;
};

MissionItemsStatusPresenter::MissionItemsStatusPresenter(QObject* object):
    BasePresenter(object),
    d(new Impl())
{
    connect(d->service, &domain::MissionService::missionItemAdded,
            this, &MissionItemsStatusPresenter::updateItemsStatus);
    connect(d->service, &domain::MissionService::missionItemRemoved,
            this, &MissionItemsStatusPresenter::updateItemsStatus);
    connect(d->service, &domain::MissionService::missionItemChanged,
            this, &MissionItemsStatusPresenter::updateItemsStatus);
}

MissionItemsStatusPresenter::~MissionItemsStatusPresenter()
{}

void MissionItemsStatusPresenter::selectMission(const dao::MissionPtr& mission)
{
    d->mission = mission;

    this->updateItemsStatus();
}

void MissionItemsStatusPresenter::selectMissionItem(const dao::MissionItemPtr& item)
{
    this->setViewProperty(PROPERTY(selectedItem), item ? item->sequence() : -1);
}

void MissionItemsStatusPresenter::connectView(QObject* view)
{
    connect(view, SIGNAL(selectItem(int)), this, SIGNAL(selectItem(int)));

    this->updateItemsStatus();
}

void MissionItemsStatusPresenter::updateItemsStatus()
{
    QStringList items;

    if (d->mission)
    {
        for (const dao::MissionItemPtr& item: d->service->missionItems(d->mission->id()))
        {
            items.append(QString::number(item->status()));
        }
    }

    this->setViewProperty(PROPERTY(items), items);
}
