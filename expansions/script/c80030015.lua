--N.千反田 爱瑠
function c80030015.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x92d4),aux.NonTuner(Card.IsSetCard,0x92d4),1)
	c:EnableReviveLimit()
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(c80030015.efilter)
	c:RegisterEffect(e0)   
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--splimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,0)
	e5:SetCondition(c80030015.splimcon)
	e5:SetTarget(c80030015.splimit)
	c:RegisterEffect(e5)
	local e3=e5:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e3)
	local e4=e5:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4)   
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_SET_ATTACK_FINAL)
	e6:SetValue(c80030015.val)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e7)
	--
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c80030015.regop)
	c:RegisterEffect(e8) 
	--damage
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(80030015,0))
	e9:SetCategory(CATEGORY_DRAW)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetCountLimit(1)
	e9:SetRange(LOCATION_MZONE)
	e9:SetOperation(c80030015.operation)
	c:RegisterEffect(e9)
end
function c80030015.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c80030015.splimit(e,c)
	return not c:IsSetCard(0x92d4)
end
function c80030015.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80030015.val(e,c)
	local ct=e:GetHandler():GetFlagEffectLabel(80030015)
	if not ct then return 0 end
	return ct
end
function c80030015.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSummonType()==SUMMON_TYPE_SYNCHRO then
		local ct=c:GetMaterialCount()
		c:RegisterFlagEffect(80030015,RESET_EVENT+0x1fe0000,0,0,ct*1000)
	end
end
function c80030015.operation(e,tp,eg,ep,ev,re,r,rp)
	local llp=Duel.GetLP(tp)
	local tlp=Duel.GetLP(1-tp)
	local m1=math.floor(math.min(llp,4000)/1000)
	local m2=math.floor(math.min(tlp,4000)/1000)
	local t1={}
	local t2={}
	for i=0,m1 do
		t1[i]=i*1000
	end
	for i=0,m2 do
		t2[i]=i*1000
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t1))
	local ec=Duel.AnnounceNumber(1-tp,table.unpack(t2))
	Duel.PayLPCost(tp,ac)
	Duel.PayLPCost(1-tp,ec)
	Duel.BreakEffect()
	if ac>ec then 
		local d=(ac-ec)/1000
		Duel.Draw(tp,d,REASON_EFFECT)
	elseif ec>ac then
		local ed=(ec-ac)/1000
		Duel.Draw(1-tp,ed,REASON_EFFECT)
	else
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(80030015,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=dg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end