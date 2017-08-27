--神匠神 断钢
function c10126009.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c10126009.fusfilter,2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)   
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c10126009.sprcon)
	e2:SetOperation(c10126009.sprop)
	c:RegisterEffect(e2)	
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10126009,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10126009)
	e3:SetTarget(c10126009.eqtg)
	e3:SetOperation(c10126009.eqop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10126009,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,10126109)
	e4:SetCondition(c10126009.spcon)
	e4:SetTarget(c10126009.sptg)
	e4:SetOperation(c10126009.spop)
	c:RegisterEffect(e4) 
end
function c10126009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1,g2,tg1,tg2,tc=Duel.GetMatchingGroup(c10126009.eqfilter,tp,0,LOCATION_GRAVE,nil,c),Duel.GetFieldGroup(c10126009.eqfilter,tp,0,LOCATION_ONFIELD,nil,c)
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and g1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and g2:GetCount()>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	   tg1=g2:Select(tp,1,1,nil)
	   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_EQUIP)   
	   tg2=g1:Select(1-tp,1,1,nil)  
	   tg1:Merge(tg2)
	   tc=tg1:GetFirst()
	   while tc do
		 if ((tg2:IsContains(tc) and Duel.Equip(1-tp,tc,c,false,true)) or (not tg2:IsContains(tc) and Duel.Equip(tp,tc,c,false,true))) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c10126009.eqlimit)
			tc:RegisterEffect(e1)
		 end
	   tc=tg1:GetNext()
	   end
	   Duel.EquipComplete()
	end
end
function c10126009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10126009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c10126009.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil,e:GetHandler()) or Duel.IsExistingMatchingCard(c10126009.eqfilter,tp,0,LOCATION_SZONE,1,nil,e:GetHandler())) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c10126009.eqfilter(c,tc)
	return c:GetSequence()<5 and ((c:IsType(TYPE_EQUIP) and not tc:CheckEquipTarget(c)) or not c:IsType(TYPE_EQUIP))
end
function c10126009.eqlimit(e,c)
	return e:GetOwner()==c
end
function c10126009.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	local tc=nil
	if ft>0 then
	  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_EQUIP)
	  tc=g:Select(1-tp,1,1,nil):GetFirst()
	elseif ft==0 and g:FilterCount(c10126009.eqfilter,nil,c)>0 then
	  Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_EQUIP)
	  tc=g:FilterSelect(1-tp,c10126009.eqfilter,1,1,nil,c):GetFirst()
	end
	  if not tc or not Duel.Equip(tp,tc,c,false) then return end
	  if not tc:IsType(TYPE_EQUIP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c10126009.eqlimit)
		tc:RegisterEffect(e1)
	  end
end
function c10126009.fusfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:GetEquipCount()>0
end
function c10126009.spfilter1(c)
	return c10126009.fusfilter(c) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial()
end
function c10126009.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c10126009.spfilter1,tp,LOCATION_MZONE,0,2,nil)
end
function c10126009.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10126009.spfilter1,tp,LOCATION_MZONE,0,2,2,nil)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end