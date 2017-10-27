--花舞少女·哈娜
local m=14141005
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c14141006") end,function() require("script/c14141006") end)
cm.named_with_hana=true
function cm.initial_effect(c)
	scorp.hana_common_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(cm.aclimit)
	e2:SetCondition(cm.actcon)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14141001,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_AVAILABLE_BD)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
end
function cm.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function cm.rfilter(c)
	return scorp.check_set_hana(c) and c:IsFaceup()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetMZoneCount(tp)
	local minct=math.max(1,-ft+1)
	if chk==0 then
		if minct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		return g:GetCount()>=minct
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()==0 then return end
	local ct=Duel.SendtoHand(g,nil,REASON_RULE)
	local ft=Duel.GetMZoneCount(tp)
	local sct=math.min(ft,ct)
	if sct==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then sct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,scorp.hanaspfilter,tp,LOCATION_HAND,0,1,sct,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end