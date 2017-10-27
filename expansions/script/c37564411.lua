--百慕 全开偶像·露璃
local m=37564411
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_prism=true
function cm.initial_effect(c)
	Senya.PrismAdvanceCommonEffect(c)
	Senya.PrismDamageCheckRegister(c,false)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(1)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(Senya.PrismDamageCheckCondition)
	e3:SetCost(cm.cost1)
	e3:SetOperation(Senya.PrismDamageCheckOperation)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(aux.bdocon)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Senya.CheckPrism(c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end