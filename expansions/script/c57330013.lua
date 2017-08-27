--早苗-H3
local m=57330013
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
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_HANDES)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(cm.condition)
	e1:SetCost(miyuki.SanaeCost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and c:IsAbleToRemove()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,0,0,0)
end
function cm.filter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and c:IsAbleToRemove()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(cm.filter,nil,e,1-tp)
	if sg:GetCount()==0 then
	local ct=0
	elseif sg:GetCount()==1 then
		ct=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		local dg=sg:Select(1-tp,1,1,nil)
		ct=Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
	end
	if ct>0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end