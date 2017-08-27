--虚无符咒
function c10113093.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c10113093.condition)
	e1:SetTarget(c10113093.target)
	e1:SetOperation(c10113093.activate)
	c:RegisterEffect(e1)	
end
function c10113093.cfilter(c)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:IsFaceup()
end
function c10113093.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10113093.cfilter,tp,LOCATION_SZONE,0,2,nil)
end
function c10113093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10113093.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,nil) end
end
function c10113093.spfilter(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c10113093.eqfilter,tp,LOCATION_DECK,0,1,nil,c,g)
end
function c10113093.eqfilter(c,ec,g)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:CheckEquipTarget(ec) and (not g or g:IsContains(c))
end
function c10113093.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local sg=g:Filter(c10113093.spfilter,nil,e,tp,g)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		   sc=sg:Select(tp,1,1,nil):GetFirst()
		   g:RemoveCard(sc)
		   if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			  ec=g:FilterSelect(tp,c10113093.eqfilter,1,1,nil,sc,nil):GetFirst()
			  Duel.Equip(tp,ec,sc,true)
			  g:RemoveCard(ec)
		   end
		end
		Duel.ShuffleDeck(tp)
	end
end