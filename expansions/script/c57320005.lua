--人偶少女·紫薰衣草
local m=57320005
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c57300000") end,function() require("script/c57300000") end)
cm.named_with_doll=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,57320001,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_EARTH),1,true,true)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCondition(cm.discon)
	e3:SetCost(miyuki.dollcost(c))
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
function cm.filter(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(cm.filter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end