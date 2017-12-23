--水歌 永奏的senya
function c12003003.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c12003003.matfilter,2,2)
	c:EnableReviveLimit()
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,12003003)
	e5:SetCost(c12003003.cost)
	e5:SetTarget(c12003003.target)
	e5:SetOperation(c12003003.activate)
	c:RegisterEffect(e5)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c12003003.damcon)
	e3:SetOperation(c12003003.damop)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c12003003.matfilter(c)
	return c:IsRace(RACE_SEASERPENT)
end
function c12003003.cfilter(c,g)
	return c:IsRace(RACE_SEASERPENT) and g:IsContains(c)
end
function c12003003.damcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c12003003.cfilter,1,nil,lg)
end
function c12003003.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,12003003)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
function c12003003.filter(c)
	return c:IsRace(RACE_SEASERPENT) and c:IsAbleToGrave()
end
function c12003003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12003003.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c12003003.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c12003003.tgfilter(c)
	return c:IsRace(RACE_SEASERPENT) and c:IsAbleToHand()
end
function c12003003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12003003.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12003003.tgfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c12003003.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c12003003.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
end