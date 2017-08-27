--Leanbox 贝尔
local m=73205004
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c73205005") end) then require("script/c73205005") end
cm.named_with_nep=true
function cm.initial_effect(c)
	nep.global1(c,m)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(m*16)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m-5000)
	e5:SetCost(cm.excost)
	e5:SetTarget(cm.extg)
	e5:SetOperation(cm.exop)
	c:RegisterEffect(e5)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost()
end
function cm.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) end
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(cm.estg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.estg(e,c)
	return nep.isnep(c)
end