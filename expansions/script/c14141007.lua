--花舞少女·花雪
local m=14141007
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c14141006") end,function() require("script/c14141006") end)
cm.named_with_hana=true
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE+LOCATION_EXTRA,0)==0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(scorp.hanaspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,scorp.hanaspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(cm.descon)
		e2:SetOperation(cm.desop)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end