--元灵的绽放·Blossom
local m=37564053
local cm=_G["c"..m]

xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_elem=true
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,4,nil,nil,63)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.discon)
	e1:SetCost(Senya.DescriptionCost())
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	Senya.CopySpellModule(c,0,0,nil,cm.xcon,nil,1,nil,nil,true)
end
function cm.xmfilter(c)
	return Senya.check_set_elem(c) and c:IsType(TYPE_XYZ) and c:GetRank()==4
end
function cm.xcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(cm.xmfilter,1,nil)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and cm.xcon(e)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and c:IsType(TYPE_XYZ) then
		Senya.OverlayCard(c,rc)
	end
end