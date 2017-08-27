--光明的梦幻-幻月
function c14140001.initial_effect(c)
	aux.AddXyzProcedure(c,nil,12,2)
	c:EnableReviveLimit()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetOverlayCount()>0
	end)
	e4:SetValue(function(e,re)
		return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
	end)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14140001,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
		e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
	end)
	e3:SetTarget(c14140001.sgtg)
	e3:SetOperation(c14140001.sgop)
	c:RegisterEffect(e3)
end
function c14140001.damfilter(c,p)
	return c:GetOwner()==p and c:IsAbleToGrave()
end
function c14140001.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local dc=g:FilterCount(c14140001.damfilter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,dc*500)
	Duel.SetChainLimit(aux.FALSE)
end
function c14140001.sgfilter(c,p)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(p)
end
function c14140001.sgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SendtoGrave(g,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(c14140001.sgfilter,nil,1-tp)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end