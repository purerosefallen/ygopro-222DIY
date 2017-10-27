--超时空战斗机-Metallion
function c13257306.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13257306,4))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c13257306.spcon)
	e1:SetTarget(c13257306.sptg)
	e1:SetOperation(c13257306.spop)
	c:RegisterEffect(e1)
	--Power Capsule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257306,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetTarget(c13257306.pctg)
	e2:SetOperation(c13257306.pcop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257306,5))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(aux.bdocon)
	e3:SetTarget(c13257306.eqtg)
	e3:SetOperation(c13257306.eqop)
	c:RegisterEffect(e3)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(c13257306.bgmop)
	c:RegisterEffect(e11)
	c13257306[c]=e2
	
end
function c13257306.spcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c13257306.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257306.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c13257306.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c13257306.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(11,0,aux.Stringid(13257306,7))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c13257306.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,tc,c)
		end
		local a=Duel.GetAttacker()
		if a:IsAttackable() and not a:IsImmuneToEffect(e) then
			Duel.CalculateDamage(a,c)
		end
	end
end
function c13257306.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=Duel.IsExistingMatchingCard(c13257306.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local t2=Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,93130022,0,0x4011,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
	if chk==0 then return t1 or t2 end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13257306,1))
	if t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257306,2),aux.Stringid(13257306,3))
	elseif t1 then
		op=Duel.SelectOption(tp,aux.Stringid(13257306,2))
	elseif t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257306,3))+1
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
function c13257306.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c13257306.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
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
		e1:SetValue(c13257306.tokenatk)
		e1:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(c13257306.tokendef)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(c13257306.tokenlv)
		e3:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(c13257306.tokenrace)
		e4:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(c13257306.tokenatt)
		e5:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_SELF_DESTROY)
		e6:SetCondition(c13257306.tokendes)
		e6:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
	end
end
function c13257306.tokenatk(e,c)
	return e:GetOwner():GetAttack()
end
function c13257306.tokendef(e,c)
	return e:GetOwner():GetDefense()
end
function c13257306.tokenlv(e,c)
	return e:GetOwner():GetLevel()
end
function c13257306.tokenrace(e,c)
	return e:GetOwner():GetRace()
end
function c13257306.tokenatt(e,c)
	return e:GetOwner():GetAttribute()
end
function c13257306.tokendes(e)
	return not e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c13257306.tdfilter(c,ec,tp)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and ((c:CheckEquipTarget(ec) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or c:IsAbleToExtra())
end
function c13257306.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c13257306.tdfilter(chkc,c,tp) end
	if chk==0 then return Duel.IsExistingTarget(c13257306.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c13257306.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil,c,tp)
end
function c13257306.eqop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local sc=sg:GetCount()
	if sc==0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>=sc and Duel.SelectYesNo(tp,aux.Stringid(13257306,6)) then
		local tc=sg:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c,true,true)
			tc=sg:GetNext()
		end
		Duel.EquipComplete()
	else
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c13257306.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257306,7))
end