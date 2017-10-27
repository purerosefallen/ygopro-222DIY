--超时空战斗机-Vixen
function c13257320.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13257320,4))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c13257320.spcost)
	e1:SetTarget(c13257320.sptg)
	e1:SetOperation(c13257320.spop)
	c:RegisterEffect(e1)
	--Power Capsule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257320,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetTarget(c13257320.pctg)
	e2:SetOperation(c13257320.pcop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257320,5))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c13257320.eqcon)
	e3:SetTarget(c13257320.eqtg)
	e3:SetOperation(c13257320.eqop)
	c:RegisterEffect(e3)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(c13257320.bgmop)
	c:RegisterEffect(e11)
	c13257320[c]=e2
	
end
function c13257320.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c13257320.spfilter(c,e,tp)
	return c:IsSetCard(0x351) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13257320.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c13257320.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c13257320.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c13257320.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c13257320.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c13257320.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257320.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=Duel.IsExistingMatchingCard(c13257320.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local t2=Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,93130022,0,0x4011,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
	if chk==0 then return t1 or t2 end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13257320,1))
	if t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257320,2),aux.Stringid(13257320,3))
	elseif t1 then
		op=Duel.SelectOption(tp,aux.Stringid(13257320,2))
	elseif t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257320,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
	elseif op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	end
end
function c13257320.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c13257320.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,tc,c)
		end
	elseif e:GetLabel()==1 then
		local atk=c:GetAttack()
		local def=c:GetDefense()
		local lv=c:GetLevel()
		local race=c:GetRace()
		local att=c:GetAttribute()
		if Duel.GetMZoneCount(tp)<=0 or not c:IsRelateToEffect(e) or c:IsFacedown()
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,93130022,0,0x4011,atk,def,lv,race,att) then return end
		local token=Duel.CreateToken(tp,93130022)
		c:CreateRelation(token,RESET_EVENT+0x1fe0000)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c13257320.tokenatk)
		e1:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(c13257320.tokendef)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(c13257320.tokenlv)
		e3:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(c13257320.tokenrace)
		e4:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(c13257320.tokenatt)
		e5:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_SELF_DESTROY)
		e6:SetCondition(c13257320.tokendes)
		e6:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
	end
end
function c13257320.tokenatk(e,c)
	return e:GetOwner():GetAttack()
end
function c13257320.tokendef(e,c)
	return e:GetOwner():GetDefense()
end
function c13257320.tokenlv(e,c)
	return e:GetOwner():GetLevel()
end
function c13257320.tokenrace(e,c)
	return e:GetOwner():GetRace()
end
function c13257320.tokenatt(e,c)
	return e:GetOwner():GetAttribute()
end
function c13257320.tokendes(e)
	return not e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c13257320.tdfilter(c,ec,tp)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and ((c:CheckEquipTarget(ec) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or c:IsAbleToExtra())
end
function c13257320.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c13257320.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c13257320.tdfilter(chkc,c,tp) end
	if chk==0 then return Duel.IsExistingTarget(c13257320.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c13257320.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,c,tp)
end
function c13257320.eqop(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not sc:IsRelateToEffect(e) then return end
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and sc:CheckEquipTarget(c) and Duel.SelectYesNo(tp,aux.Stringid(13257320,6)) then
		Duel.Equip(tp,sc,c)
	else
		Duel.SendtoDeck(sc,nil,2,REASON_EFFECT)
	end
end
function c13257320.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257320,7))
end
