--超时空战斗机-Vic Viper
function c13257301.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13257301,2))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c13257301.eqtg)
	e1:SetOperation(c13257301.eqop)
	c:RegisterEffect(e1)
	--Power Capsule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13257301,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetTarget(c13257301.pctg)
	e2:SetOperation(c13257301.pcop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257301,5))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,13257301)
	e3:SetTarget(c13257301.sptg)
	e3:SetOperation(c13257301.spop)
	c:RegisterEffect(e3)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(c13257301.bgmop)
	c:RegisterEffect(e11)
	c13257301[c]=e2
end
function c13257301.eqfilter(c,ec)
	return c:IsSetCard(0x352) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257301.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c13257301.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c13257301.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c13257301.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c13257301.thfilter(c)
	return c:IsSetCard(0x351) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c13257301.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=Duel.IsExistingMatchingCard(c13257301.eqfilter,tp,LOCATION_EXTRA,0,1,nil,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local t2=Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,93130022,0,0x4011,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
	local t3=Duel.IsExistingMatchingCard(c13257301.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return t1 or t2 or t3 end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(13257301,1))
	if t1 and t2 and t3 then
		op=Duel.SelectOption(tp,aux.Stringid(13257301,2),aux.Stringid(13257301,3),aux.Stringid(13257301,4))
	elseif t1 and t2 then
		op=Duel.SelectOption(tp,aux.Stringid(13257301,2),aux.Stringid(13257301,3))
	elseif t1 and t3 then
		op=Duel.SelectOption(tp,aux.Stringid(13257301,2),aux.Stringid(13257301,4))
		if op==1 then op=2 end
	elseif t2 and t3 then
		op=Duel.SelectOption(tp,aux.Stringid(13257301,3),aux.Stringid(13257301,4))
		op=op+1
	elseif t1 then op=Duel.SelectOption(tp,aux.Stringid(13257301,2))
	elseif t2 then op=Duel.SelectOption(tp,aux.Stringid(13257301,3))+1
	elseif t3 then op=Duel.SelectOption(tp,aux.Stringid(13257301,4))+2
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
	elseif op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c13257301.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c13257301.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
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
		e1:SetValue(c13257301.tokenatk)
		e1:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(c13257301.tokendef)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(c13257301.tokenlv)
		e3:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(c13257301.tokenrace)
		e4:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(c13257301.tokenatt)
		e5:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_SELF_DESTROY)
		e6:SetCondition(c13257301.tokendes)
		e6:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c13257301.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c13257301.tokenatk(e,c)
	return e:GetOwner():GetAttack()
end
function c13257301.tokendef(e,c)
	return e:GetOwner():GetDefense()
end
function c13257301.tokenlv(e,c)
	return e:GetOwner():GetLevel()
end
function c13257301.tokenrace(e,c)
	return e:GetOwner():GetRace()
end
function c13257301.tokenatt(e,c)
	return e:GetOwner():GetAttribute()
end
function c13257301.tokendes(e)
	return not e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c13257301.spfilter(c,e,tp)
	return c:IsSetCard(0x351) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13257301.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetMZoneCount(tp)
	local c=e:GetHandler()
	if chk==0 then return ft>-1 and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c13257301.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	local sg=c:GetEquipGroup()
	sg:KeepAlive()
	e:SetLabelObject(sg)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c13257301.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13257301.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		local sg=e:GetLabelObject()
		local sc=sg:GetCount()
		local tc=sg:GetFirst()
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>=sc then
			tc=sg:GetFirst()
			while tc do
				Duel.Equip(tp,tc,g:GetFirst(),true,true)
				tc=sg:GetNext()
			end
			Duel.EquipComplete()
		end
	end
end
function c13257301.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257301,7))
end
