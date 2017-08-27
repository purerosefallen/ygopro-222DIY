--恋爱Circulation
local m=37564045
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,0))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCost(Senya.RemoveOverlayCost(1))
	e7:SetTarget(cm.destg)
	e7:SetOperation(cm.desop)
	c:RegisterEffect(e7)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.reptg)
	c:RegisterEffect(e2)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function cm.f(c,e)
	return c:IsAbleToGraveAsCost() and not c:IsImmuneToEffect(e)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>0 and Duel.IsExistingMatchingCard(cm.f,tp,0,LOCATION_ONFIELD,1,nil,e) end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.f,tp,0,LOCATION_ONFIELD,1,1,nil,e)
		Duel.SendtoGrave(g,REASON_EFFECT)
		return true
	else return false end
end