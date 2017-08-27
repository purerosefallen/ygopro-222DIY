--早苗-H2
local m=57330012
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c57300000") end,function() require("script/c57300000") end)
cm.named_with_sanae=true
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCondition(cm.condition1)
	e1:SetCost(miyuki.SanaeCost)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(Card.IsAbleToRemove,nil)
	if chk==0 then return g:GetCount()>0 and e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsAbleToRemove,nil)
	Duel.NegateSummon(g)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end